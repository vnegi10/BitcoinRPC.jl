# Generate a valid body for HTTP request
function generate_body(RPC_name::String, params)

	body_dict = Dict("method" => RPC_name, 
		             "params" => params, 
		                 "id" => "jsonrpc")
	
	body = JSON.json(body_dict)

	return body
end	

# Post a HTTP request
function post_request(auth::UserAuth, RPC_name::String; params = [])

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

	result = response_dict["result"]

	if "time" in keys(result)
		result["time"] = unix2datetime(result["time"])
	end

	return result
end	