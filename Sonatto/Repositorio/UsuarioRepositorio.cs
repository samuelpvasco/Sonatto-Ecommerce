using Dapper;
using MySql.Data.MySqlClient;
using Sonatto.Models;
using Sonatto.Repositorio.Interfaces;
using System.Data;

namespace Sonatto.Repositorio
{
    public class UsuarioRepositorio : IUsuarioRepositorio
    {
        private readonly string _connectionString;

        public UsuarioRepositorio(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<Usuario?> ObterPorId(int idUsuario)
        {
            using var conn = new MySqlConnection(_connectionString);

            var sql = @"SELECT * FROM tbUsuario 
                        WHERE IdUsuario = @IdUsuario";

            return await conn.QueryFirstOrDefaultAsync<Usuario>(sql, new { IdUsuario = idUsuario });
        }

        public async Task<Usuario?> ObterPorEmail(string email)
        {
            using var conn = new MySqlConnection(_connectionString);

            var sql = @"SELECT * FROM tbUsuario 
                        WHERE Email = @Email";

            return await conn.QueryFirstOrDefaultAsync<Usuario>(sql, new { Email = email });
        }

        public async Task<Usuario?> ObterPorEmailSenha(string email, string senha)
        {
            using var conn = new MySqlConnection(_connectionString);

            var sql = @"SELECT * FROM tbUsuario 
                        WHERE Email = @Email AND Senha = @Senha";

            return await conn.QueryFirstOrDefaultAsync<Usuario>(sql, new
            {
                Email = email,
                Senha = senha
            });
        }

        public async Task<int> CadastrarUsuario(Usuario usuario)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();

            parametros.Add("vEmail", usuario.Email);
            parametros.Add("vNome", usuario.Nome);
            parametros.Add("vSenha", usuario.Senha);
            parametros.Add("vCPF", usuario.CPF);
            parametros.Add("vEndereco", usuario.Endereco);
            parametros.Add("vTelefone", usuario.Telefone);

            // parâmetro de saída com nome correto
            parametros.Add("vIdCli", dbType: DbType.Int32, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("sp_CadastroUsu", parametros, commandType: CommandType.StoredProcedure);

            return parametros.Get<int>("vIdCli");
        }


        public async Task AlterarUsuario(Usuario usuario)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();

            parametros.Add("vIdUsuario", usuario.IdUsuario);
            parametros.Add("vEmail", usuario.Email);
            parametros.Add("vNome", usuario.Nome);
            parametros.Add("vSenha", usuario.Senha);
            parametros.Add("vCPF", usuario.CPF);
            parametros.Add("vEndereco", usuario.Endereco);
            parametros.Add("vTelefone", usuario.Telefone);

            await conn.ExecuteAsync("sp_AlterarUsu", parametros, commandType: CommandType.StoredProcedure);
        }

        

       
    }
}
