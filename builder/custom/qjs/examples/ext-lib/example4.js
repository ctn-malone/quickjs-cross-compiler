import { sshExec } from 'ext/ssh.js';
import * as std from 'std';

/*
    Execute 'date' command over ssh on localhost
 */

const main = async () => {
    try {
        const stdout = await sshExec('127.0.0.1', 'date');
        console.log(`Date: ${stdout}`);
    }
    catch (e) {
        if (undefined !== e.sshErrorReason) {
            console.log(`SSH failed (${e.sshErrorReason}) : ${e.sshError}`);
        }
        else {
            console.log(`SSH failed : ${e.message}`);
        }
        std.exit(1);
    }
}

main();
