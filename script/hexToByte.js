/*

attempt to convert a message or address to bytes to submit to the network.

# FIX-ME

*/

const explorerHelpers = require("@theqrl/explorer-helpers")

const args = process.argv.slice(2);
console.log('args: ', args);


async function main(){
        const data = args[0];

        const bytes = await explorerHelpers.hexAddressToRawAddress(data);
        console.log(JSON.stringify(bytes));

};

main();
