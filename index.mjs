import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from "./build/mv.main.mjs";
import dotenv from 'dotenv';

dotenv.config();
(async() => {
    const reachStdlib = await loadStdlib(process.env);
    const [Admin, Organization, Student] = await reachStdlib.newTestAccount(reachStdlib.parceCurrency(100));
    const contract = Admin.contract(backend);
    contract.getInfo().then(info => {
        console.log(info);
    });


    // const meta = reachStdlib.newBytes(256);
    // const upload = reachStdlib.newBytes(96);
    // const [okay,want] = reachStdlib.newBool();



})();