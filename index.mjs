import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from "./build/mv.main.mjs";
import dotenv from 'dotenv';

dotenv.config();
(async() => {
    const reachStdlib = await loadStdlib(process.env);
    const [Admin, Organization, Student] = await reachStdlib.newTestAccount(reachStdlib.parceCurrency(100));
    const contract = Student.contract(backend);

    const [meta, upload] = reachStdlib.newBytes(256);
    const [okay,want] = reachStdlib.newBool();


})();