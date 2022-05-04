# BitcoinRPC.jl

This package provides a Julia interface to Bitcoin's JSON-RPC API. 
Only [blockchain and mining RPCs](https://developer.bitcoin.org/reference/rpc/index.html) 
have been implemented for now. They should be enough for performing on-chain analytics, which is
the primary motivation here. Remaining ones will be added later if necessary. Pull requests are 
always welcome! 

## How to install?

```julia
using Pkg
Pkg.add("https://github.com/vnegi10/BitcoinRPC.jl.git")
```

## Prerequisite

You will need to run a full node using either the GUI from 
[Bitcoin Core](https://bitcoin.org/en/bitcoin-core/) or the headless version called `bitcoind`.
See instructions [here.](https://en.bitcoinwiki.org/wiki/Running_Bitcoind) The daemon can also be
started with a `bitcoin.conf` configuration file, which can be generated
[here.](https://jlopp.github.io/bitcoin-core-config-generator/)

The configuration file should have the RPC options enabled, which will allow our package to
communicate with the node's RPC server. Setting a username and password is a must, as those
credentials will be used for authentication. An example is shown below:

```
# [rpc]
# Accept command line and JSON-RPC commands.
server=1
# Username and hashed password for JSON-RPC connections. The field <userpw> comes in the format: <USERNAME>:<SALT>$<HASH>. RPC clients connect using rpcuser=<USERNAME>/rpcpassword=<PASSWORD> arguments. You can generate this value at https://jlopp.github.io/bitcoin-core-rpc-auth-generator/. This option can be specified multiple times.
rpcauth=vnegi10:e505cc439280783b65b57835c814fbe2$5cbb256435336a3c95a2545e4d4098d051e2bbd245f3831b6f2a172844aaf8e7
# Listen for JSON-RPC connections on this port
rpcport=8332
# Set the number of threads to service RPC calls
rpcthreads=8
# Set the depth of the work queue to service RPC calls
rpcworkqueue=32
```

Once the GUI or daemon is started, the software will download a copy of the entire blockchain onto
your disk. This means that you will have data starting from the first block (mined in 2009), also
known as the genesis block. Default download location is usually at ~/.bitcoin/, but you are free
to select another one. Keep in mind that you need ~ 424 GB space (as of 11–04–2022) in case you
want the most recent blocks. This is the recommended way to get authentic and reliable data, as it
is fetched from a trusted set of peers, which are usually other nodes running on computers around
the world. It's wise not to trust any other sources.

## Help

Some examples of available functions along with the expected output are shown below. Detailed
usage information can also be obtained via REPL help:
* Press '?' to enter the help mode
* Type function name and press enter

**Documentation:** [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://vnegi10.github.io/BitcoinRPC.jl/stable)

## Example usage

```julia
auth = UserAuth("rpcuser", "rpcpassword", rpcport)
```

```julia
julia> show_block(auth, blockhash = show_best_block_hash(auth), verbosity = 1)
Dict{String, Any} with 18 entries:
  "time"              => DateTime("2022-04-30T16:06:39")
  "difficulty"        => 2.97944e13
  "bits"              => "17097275"
  "previousblockhash" => "00000000000000000002bd10c4a5ed735df0f860be0b1b47ce12a3f5be8ad9f6"
  "merkleroot"        => "19b3732ebf608a27e6e0c83e351f0a01f9d86016d466ae94190e74ab8b29801e"
  "height"            => 734262
  "confirmations"     => 1
  "strippedsize"      => 856000
  "version"           => 538968064
  "hash"              => "00000000000000000005089254e190446199a35441943fb1ad34d46fbaad3271"
  "tx"                => Any["5e4a16d49ee79083636f24138c9e27d28daad5c607f80427ffdc1a4f4251b3b7", "e068afb1fd759ed967bba4a0c925bf22d13283…
  "size"              => 1425426
  "versionHex"        => "20200000"
  "weight"            => 3993426
  "mediantime"        => DateTime("2022-04-30T14:18:16")
  "nTx"               => 2826
  "chainwork"         => "00000000000000000000000000000000000000002cf79dc7911c9663902061d0"
  "nonce"             => 2198508859
  ```

  ```julia
  julia> show_chain_txstats(auth, nblocks = 1440, blockhash = show_block_hash(auth, height = 700000))
Dict{String, Any} with 8 entries:
  "txcount"                   => 669566382
  "window_tx_count"           => 2512428
  "time"                      => DateTime("2021-09-11T04:14:32")
  "window_interval"           => 821264
  "window_final_block_height" => 700000
  "window_final_block_hash"   => "0000000000000000000590fc0f3eba193a278534220b2b37e9849e1a770ca959"
  "window_block_count"        => 1440
  "txrate"                    => 3.05922
  ```

  ```julia
  julia> collect_block_stats(auth, 700_000, 700_010)
11×28 DataFrame
 Row │ avgfee      avgfeerate  avgtxsize  blockhash                          height  ins    maxfee      maxfeerate  maxtxsize  medianfe ⋯
     │ Float64     Float64     Int64      String                             Int64   Int64  Float64     Float64     Int64      Float64  ⋯
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 0.00012069      1.5e-7       1000  0000000000000000000590fc0f3eba19…  700000   6342  0.014          3.58e-6      86228   1.512e- ⋯
   2 │ 2.078e-5        2.0e-8        956  00000000000000000002f39baabb00ff…  700001   2435  0.00153        2.51e-6      46044   3.36e-6
   3 │ 4.082e-5        8.0e-8        627  00000000000000000001993b6b5e4e3d…  700002    729  0.00059549     3.16e-6      22613   1.363e-
   4 │ 0.00025372      3.5e-7        981  000000000000000000055646f272b32b…  700003    716  0.025465       2.02e-6      35443   1.486e-
   5 │ 5.484e-5        1.1e-7        831  0000000000000000000e360e05cb9d7b…  700004   1174  0.0028332      4.77e-6      53046   1.323e- ⋯
  ⋮  │     ⋮           ⋮           ⋮                      ⋮                    ⋮       ⋮        ⋮           ⋮           ⋮          ⋮    ⋱
   8 │ 8.023e-5        1.6e-7        723  0000000000000000000a5f9662af9517…  700007   4141  0.00584712     3.89e-6      72988   1.333e-
   9 │ 6.225e-5        1.5e-7        562  0000000000000000000bd59e42336960…  700008   6130  0.00388224     6.05e-6      61070   1.396e-
  10 │ 3.048e-5        5.0e-8        703  0000000000000000000190997c460412…  700009   2176  0.00164097     1.55e-6      46079   4.52e-6
  11 │ 0.00010499      2.1e-7        597  00000000000000000001a6a742dcef16…  700010    384  0.00641376     1.55e-6       9780   1.343e- ⋯
  ```