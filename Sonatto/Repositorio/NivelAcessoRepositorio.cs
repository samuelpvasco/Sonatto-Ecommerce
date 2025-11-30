using Dapper;
using Dapper;
using MySql.Data.MySqlClient;
using Sonatto.Repositorio.Interfaces;
using System.Data;
using System.Collections.Generic;
using System.Threading.Tasks;
using Sonatto.Models;

namespace Sonatto.Repositorio
{
    public class NivelAcessoRepositorio : INivelAcessoRepositorio
    {
        private readonly string _connectionString;
        public NivelAcessoRepositorio(string connectionString)
        {
            _connectionString = connectionString;
        }
        
        public async Task GerenciarNivel(int idUsuario, string acao,int idNivel)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();

            parametros.Add("vIdUsuario", idUsuario);
            parametros.Add("vAcao", acao);
            parametros.Add("vIdNivel", idNivel);
            

            await conn.ExecuteAsync("sp_GerenciarNivel", parametros, commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<NivelAcesso>> GetNiveisPorUsuario(int idUsuario)
        {
            using var conn = new MySqlConnection(_connectionString);
            var sql = @"
                SELECT n.NomeNivel, n.IdNivel
                FROM tbNivelAcesso n
                JOIN tbUsuNivel u ON n.IdNivel = u.IdNivel
                WHERE u.IdUsuario = @IdUsuario
            ";

            var resultados = await conn.QueryAsync<NivelAcesso>(sql, new { IdUsuario = idUsuario });
            return resultados;
        }

        public async Task<IEnumerable<UsuariosNiveisViewModel>> GetTodosNiveis()
        {
            using var conn = new MySqlConnection(_connectionString);
            var sql = @"SELECT * FROM vw_NiveisFunc";
            var resultados = await conn.QueryAsync<UsuariosNiveisViewModel>(sql);
            return resultados;
        }

    }
}
