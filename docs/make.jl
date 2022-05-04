using Documenter
using BitcoinRPC

makedocs(
    sitename = "BitcoinRPC",
    format = Documenter.HTML(),
    modules = [BitcoinRPC]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/vnegi10/BitcoinRPC.jl.git",
    devbranch = "main"
)
