unit queries;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const

  //----------------  query´s clientes --------------------------
  listarClientes = 'SELECT * FROM pessoas WHERE cliente=1';

  listarFornecedores = 'SELECT p.* FROM pessoas p WHERE p.fornecedor=1';

  listarPessoas = 'SELECT * FROM pessoas';

  insereCliente = 'INSERT INTO PESSOAS(cliente,fornecedor,nome,apelido_nome_fantasia,' +
    'tipo_pessoa,cpf_cnpj,cidade,uf,bairro,logradouro,numero,complemento) ' +
    'VALUES(1,0,:nome,:apelido,:pessoa,:cpfcnpj,:cidade,:uf,:bairro,:logradouro,' +
    ':numero,:complemento) RETURNING id';

  atualizaCliente = 'UPDATE pessoas SET nome=:nome,apelido_nome_fantasia=:apelido,' +
    'tipo_pessoa=:pessoa,cpf_cnpj=:cpfcnpj,rg=:rg,ie=:ie,cidade=:cidade,uf=:uf,bairro=:bairro,' +
    'logradouro=:logradouro,numero=:numero,complemento=:complemento WHERE id=:id RETURNING id';

  insereFornecedor = 'INSERT INTO PESSOAS(cliente,fornecedor,nome,apelido_nome_fantasia,' +
    'tipo_pessoa,cpf_cnpj,rg,ie,cidade,uf,bairro,logradouro,numero,complemento) ' +
    'VALUES(0,1,:nome,:apelido,:pessoa,:cpfcnpj,:rg,:ie,:cidade,:uf,:bairro,:logradouro,' +
    ':numero,:complemento) RETURNING id';

  atualizaFornecedor = 'UPDATE pessoas SET nome=:nome,apelido_nome_fantasia=:apelido,' +
    'tipo_pessoa=:pessoa,cpf_cnpj=:cpfcnpj,rg=:rg,ie=:ie,cidade=:cidade,uf=:uf,bairro=:bairro,' +
    'logradouro=:logradouro,numero=:numero,complemento=:complemento WHERE id=:id RETURNING id';

  inserePessoa = 'INSERT INTO PESSOAS(cliente,fornecedor,nome,apelido_nome_fantasia,' +
    'tipo_pessoa,cpf_cnpj,cidade,uf,bairro,logradouro,numero,complemento) ' +
    'VALUES(:cli,:for,:nome,:apelido,:pessoa,:cpfcnpj,:cidade,:uf,:bairro,:logradouro,' +
    ':numero,:complemento) RETURNING id';

  atualizaPessoa = 'UPDATE pessoas SET cliente=:cli,fornecedor=:for,nome=:nome,apelido_nome_fantasia=:apelido,' +
    'tipo_pessoa=:pessoa,cpf_cnpj=:cpfcnpj,rg=:rg,ie=:ie,cidade=:cidade,uf=:uf,bairro=:bairro,' +
    'logradouro=:logradouro,numero=:numero,complemento=:complemento WHERE id=:id RETURNING id';

  cpfJaCadastrado = 'SELECT p.id FROM pessoas p WHERE p.cpf_cnpj=:inscricao';

  deletarPessoa = 'DELETE FROM pessoas p WHERE p.id=:id';

  idEmUso = 'SELECT p.id FROM PEDIDOS p WHERE p.idpessoa=:id';

  //----------------  query´s produtos --------------------------


implementation

end.

