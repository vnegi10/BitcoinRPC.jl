# Generate a valid body for HTTP request
function generate_body(RPC_name::String, params)

	body_dict = Dict("method"  => RPC_name, 
		             "params"  => params, 
		             "id"      => 1,
                     "jsonrpc" => "2.0")
	
	body = JSON.json(body_dict)

	return body
end	

# Post a HTTP request
function post_request(auth::UserAuth, RPC_name::String; params)

	url = "http://$(auth.name):$(auth.pass)@127.0.0.1:$(auth.port)"

	body = generate_body(RPC_name, params)
	headers = ["Content-Type" => "application/json"]

	response = HTTP.request(
        "POST",
        url,
        headers,
        body;
        verbose = 0,
        retries = 2
    )

	response_dict = String(response.body) |> JSON.parse

    if ~("result" in keys(response_dict))
        error("missing JSON-RPC result")
    end    

	result = response_dict["result"]

    # Convert UNIX epoch to DateTime
    key_names = ["time", "mediantime"]

    for key ∈ key_names        
        if key in keys(result)
            result[key] = unix2datetime(result[key])
        end
    end

	return result
end	

# Add support for batch requests
function generate_body_batch(RPC_name::String, params::String)

    params = convert_to_int(params)

	bodies = Dict{String, Any}[]
	i = 1

	for param in params		
		body_dict = Dict("method" => RPC_name, 
		                 "params" => [param], 
		                 "id" => i,
		                "jsonrpc" => "2.0")
		push!(bodies, body_dict)
		i += 1
	end
	
	return JSON.json(bodies)
end

function post_request_batch(auth::UserAuth, RPC_name::String; params::String)

	url = "http://$(auth.name):$(auth.pass)@127.0.0.1:8332"

	bodies = generate_body_batch(RPC_name, params)
	headers = ["Content-Type" => "application/json"]

	response = HTTP.request(
        "POST",
        url,
        headers,
        bodies;
        verbose = 0,
        retries = 2
    )

	response_dicts = String(response.body) |> JSON.parse

    #= Keep it like this since results can be Strings (hashes), 
    Numbers or Dicts =#
	results = Any[]

	for response_dict in response_dicts		
		result = response_dict["result"]

		if "time" in keys(result)
			result["time"] = unix2datetime(result["time"])
		end	

		push!(results, result)
	end

	return results
end