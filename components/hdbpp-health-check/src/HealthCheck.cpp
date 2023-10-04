// Copyright (C) : 2014-2017
// European Synchrotron Radiation Facility
// BP 220, Grenoble 38043, FRANCE
//
// This file is part of HdbppHealthCheck
//
// HdbppHealthCheck is free software: you can redistribute it and/or modify
// it under the terms of the Lesser GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// HdbppHealthCheck is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the Lesser
// GNU General Public License for more details.
//
// You should have received a copy of the Lesser GNU General Public License
// along with HdbppHealthCheck.  If not, see <http://www.gnu.org/licenses/>.


#include "HealthCheck.h"

#include "httplib.h"
#include "rapidjson/document.h"
#include <tango/tango.h>
#include <iostream>

namespace HdbppHealthCheck_ns
{

HealthCheck::HealthCheckResult HealthCheck::to_healthcheck_result(const std::string& state) const
{
    if (state == "Ok")
        return HealthCheckResult::Ok;

    else if (state == "Warning")
        return HealthCheckResult::Warning;

    else if (state == "Error")
        return HealthCheckResult::Error;
    
    else 
        return HealthCheckResult::ConnectionProblem;

}

//=============================================================================
//=============================================================================
bool HealthCheck::configure_rest_server_address(const std::string &host, int port, const std::string &root_url)
{
    if (host.empty() || root_url.empty())
        return false;

    _host = host;
    _port = port;
    _root_url = root_url;

    // quickly check if the given details can connect to a a server
    httplib::Client cli(_host, _port);
    auto url = _root_url + "/";
    auto result = cli.Get(url.c_str());
    
    return !(result == nullptr);
}

//=============================================================================
//=============================================================================
std::tuple<HealthCheck::HealthCheckResult, std::string> HealthCheck::check_hosts() const
{
    assert(!_host.empty());
    assert(!_root_url.empty());

    if (_health_endpoints.empty())
        Tango::Except::throw_exception("Bad Configuration", 
            "Attempting to check hosts when no endpoints have been configured", (const char *)__func__);

    std::string error_message = "";
    HealthCheckResult health_result = HealthCheckResult::Ok;
    std::tuple<HealthCheck::HealthCheckResult, std::string> ret;

    // contact the cluster reporting server and request the server
    // health status
    httplib::Client cli(_host, _port);
    for(auto it = _health_endpoints.cbegin(); it != _health_endpoints.cend(); ++it)
    {
        auto url = _root_url + *it;
        auto result = cli.Get(url.c_str());
        
        if (result && result->status == 200) 
        {
            rapidjson::Document document;
            document.Parse(result->body.c_str());

            if (!document.IsObject() || !document.HasMember("state") || !document["state"].IsString())
                return std::make_tuple(HealthCheckResult::ConnectionProblem, invalid_response);

            // Retrieve the error message if there is any
            if (document.HasMember("message") && document["message"].IsString())
                error_message += "\n" + std::string(document["message"].GetString());
            
            // get a valid reponse, now check the cluster
            std::string state = std::string(document["state"].GetString());
            HealthCheck::HealthCheckResult res = to_healthcheck_result(state);
            
            if(res > health_result)
                health_result = res;
        }
        
        else
            return std::make_tuple(HealthCheckResult::ConnectionProblem, no_reponse);
    }
    
    switch(health_result)
    {
        case Ok:
            ret = std::make_tuple(HealthCheckResult::Ok, server_no_errors + error_message);
            break;
        case Warning:
            ret = std::make_tuple(HealthCheckResult::Warning, server_warning + error_message);
            break;
        case Error:
            ret = std::make_tuple(HealthCheckResult::Error, server_error + error_message);
            break;
        default:
            ret = std::make_tuple(
                HealthCheckResult::ConnectionProblem, server_bad_response + error_message);
    }
    return ret;
}

} // namespace HdbppHealthCheck_ns
