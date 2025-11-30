using Dapper;
using MySql.Data.MySqlClient;
using Sonatto.Models;
using Sonatto.Repositorio.Interfaces;

namespace Sonatto.Repositorio
{
    public class HistoricoAcaoRepositorio : IHistoricoAcaoRepositorio
    {
        private readonly string _connectionString;

        public HistoricoAcaoRepositorio(string connectionString)
        {
            _connectionString = connectionString;
        }
        public async Task<IEnumerable<HistoricoAcao>> BuscarHistoricoAcao()
        {
            using var conn = new MySqlConnection(_connectionString);

            var sql = @"SELECT * FROM vw_HistoricoAcao ORDER BY DataAcao DESC;";

            return await conn.QueryAsync<HistoricoAcao>(sql);
        }

        public async Task<IEnumerable<HistoricoAcao>> BuscarHistoricoAcaoFunc(int idUsuario)
        {
            using var conn = new MySqlConnection(_connectionString);

            var sql = @"SELECT * FROM vw_HistoricoAcao WHERE IdUsuario = @IdUsuario ORDER BY DataAcao DESC;";

            return await conn.QueryAsync<HistoricoAcao>(sql, new { IdUsuario = idUsuario });
        }
    }
}
