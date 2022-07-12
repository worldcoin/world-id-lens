import fs from 'fs'
import ora from 'ora'
import dotenv from 'dotenv'
import readline from 'readline'
import { Wallet } from '@ethersproject/wallet'
import { hexlify, concat } from '@ethersproject/bytes'
import { JsonRpcProvider } from '@ethersproject/providers'
import { defaultAbiCoder as abi } from '@ethersproject/abi'
dotenv.config()

const HumanCheck = JSON.parse(fs.readFileSync('./out/HumanCheck.sol/HumanCheck.json', 'utf-8'))

let validConfig = true
if (process.env.RPC_URL === undefined) {
    console.log('Missing RPC_URL')
    validConfig = false
}
if (process.env.PRIVATE_KEY === undefined) {
    console.log('Missing PRIVATE_KEY')
    validConfig = false
}
if (!validConfig) process.exit(1)

const provider = new JsonRpcProvider(process.env.RPC_URL)
const wallet = new Wallet(process.env.PRIVATE_KEY, provider)

const ask = async question => {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    })

    return new Promise(resolve => {
        rl.question(question, input => {
            resolve(input)
            rl.close()
        })
    })
}

async function main() {
    const network = await provider.getNetwork()
    if (![137, 80001].includes(network.chainId)) {
        console.log('WorldID is only available in Polygon (and the Mumbai testnet).')
        process.exit(1)
    }

    const worldIDAddress = await fetch('https://developer.worldcoin.org/api/v1/contracts')
        .then(res => res.json())
        .then(
            res =>
                res.find(
                    ({ key }) =>
                        key == `${network.chainId === 80001 ? 'staging.' : ''}semaphore.wld.eth`
                ).value
        )

    const spinner = ora(`Deploying HumanCheck...`).start()

    let tx = await wallet.sendTransaction({
        data: hexlify(
            concat([
                HumanCheck.bytecode.object,
                abi.encode(HumanCheck.abi[0].inputs, [worldIDAddress, 1, await ask('Action ID: ')]),
            ])
        ),
    })

    spinner.text = `Waiting for deploy transaction (tx: ${tx.hash})`
    tx = await tx.wait()

    spinner.succeed(`Deployed HumanCheck to ${tx.contractAddress}`)
}

main(...process.argv.splice(2)).then(() => process.exit(0))
