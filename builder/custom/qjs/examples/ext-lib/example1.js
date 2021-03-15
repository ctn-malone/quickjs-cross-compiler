import { exec } from 'ext/process.js';

/*
    Run 3 external commands in parallel
 */

const main = async () => {
    const commands = [
        'date',
        'uptime',
        'which sh'
    ];
    const promises = [];
    commands.forEach(c => promises.push(exec(c)));
    (await Promise.all(promises)).forEach((output, i) => {
        console.log(`${commands[i]} => ${output}`);
    });
}

main();
