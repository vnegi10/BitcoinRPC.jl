################# Helper functions #################

function do_try_catch(auth::UserAuth, method::String; params = [])

    result = ""

    try
        result = post_request(auth, method; params)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            code = e.status
            if code == 404
                @warn("input method is likely NOK")
                error("HTTP - Not Found")
                
            elseif code == 500
                @warn("input parameter is likely NOK")
                error("HTTP - Internal Server Error")

            else
                error("$(e)")
            end
        else
            error("Something went wrong, check $(e)!")
        end
    end

    return result
end

# Convert Satoshis to BTC
function sato_to_btc!(result)

    all_keys = keys(result) |> collect

    for key in all_keys
        if occursin("fee", key)
            result[key] /= 1e8
        end
    end

    return result
end