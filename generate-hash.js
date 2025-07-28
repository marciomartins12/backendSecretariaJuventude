const bcrypt = require('bcryptjs');

const password = 'admin123';
const hash = bcrypt.hashSync(password, 12);

console.log('Senha:', password);
console.log('Hash:', hash);
console.log('Verificação:', bcrypt.compareSync(password, hash));
