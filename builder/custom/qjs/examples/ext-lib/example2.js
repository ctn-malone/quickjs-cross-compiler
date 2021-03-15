import arg from 'ext/arg.js';
import * as path from 'ext/path.js';
import { exec } from 'ext/process.js';

import * as std from 'std';

/*
    Simple CLI example
 */

const COMMANDS = ['date', 'uptime'];

const getUsage = () => {
    const message = `
Usage: ${path.getScriptName(true)} [-h|--help] [-c|--command] [-v|--verbose]
    -c  --command:  run command
                    Should be one of [${COMMANDS.join(',')}]
    -v  --verbose:  enable verbose mode
    -h, --help:     print help
`.trim();
    return message;
}

const getHelp = () => {
    const message = `
Run a command
`.trim();
    return `${message}\n${getUsage()}`;
}

let args;
try {
    args = arg({
        '--command': (v, n, p) => {
            const value = v.trim();
            if (!COMMANDS.includes(value)) {
                const err = new Error(`Invalid option value: ${n} (${v}) (should be one of [${COMMANDS.join(',')}])`);
                err.code = 'ARG_INVALID_OPTION';
                throw err;
            }
            return value;
        },
        '--help': Boolean,
        '--verbose':Boolean,
        // aliases
        '-c': '--command',
        '-v': '--verbose',
    	'-h': '--help'
    });
}
catch (e) {
    switch (e.code) {
        case 'ARG_UNKNOWN_OPTION':
        case 'ARG_INVALID_OPTION':
        case 'ARG_MISSING_REQUIRED_SHORTARG':
        case 'ARG_MISSING_REQUIRED_LONGARG':
            std.err.printf(`${e.message.trim()}\n`);
            std.err.printf(`${getUsage()}\n`);
            std.exit(2);
    }
    throw e;
}
if (args['--help']) {
    std.err.printf(`${getHelp()}\n`);
    std.exit(2);
}

// ensure all required arguments were provided
['--command'].forEach((n) => {
    if (undefined === args[n]) {
        std.err.printf(`Option ${n} is required\n`);
        std.err.printf(`${getUsage()}\n`);
        std.exit(2);
    }
});

if (args['--verbose']) {
    console.log(`Will run command '${args['--command']}'`);
}
exec(args['--command']).then((output) => {
    console.log(output);
});
