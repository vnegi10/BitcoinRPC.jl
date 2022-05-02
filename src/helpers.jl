################# Helper functions #################

function do_try_catch(auth::UserAuth, method::String; params = [])

    result = ""

    try
        result = post_request(auth, method; params)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            code = e.status
            if code == 404
                error("HTTP - Not Found")
            elseif code == 500
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