struct UserAuth
    name::String
    pass::String
    port::Int64
end

StringOrInt = Union{String,Int64}