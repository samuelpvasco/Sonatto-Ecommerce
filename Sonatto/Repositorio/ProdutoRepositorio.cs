using Dapper;
using MySql.Data.MySqlClient;
using Sonatto.Models;
using Sonatto.Repositorio.Interfaces;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Collections.Generic;
using System;
using System.Threading.Tasks;

namespace Sonatto.Repositorio
{
    public class ProdutoRepositorio : IProdutoRepositorio
    {
        private readonly string _connectionString;

        public ProdutoRepositorio(string connectionString)
        {
            _connectionString = connectionString;
        }



        public async Task AdicionarImagens(int idProduto, string url)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();

            parametros.Add("vIdProduto", idProduto);
            parametros.Add("vImagemUrl", url);

            await conn.ExecuteAsync("sp_AdicionarImagens", parametros, commandType: CommandType.StoredProcedure);
        }

        public async Task<int> AdicionarProduto(Produto produto, int idUsu)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();
            parametros.Add("vNomeProduto", produto.NomeProduto);
            parametros.Add("vPreco", produto.Preco);
            parametros.Add("vDescricao", produto.Descricao);
            parametros.Add("vMarca", produto.Marca);
            parametros.Add("vAvaliacao", produto.Avaliacao);
            parametros.Add("vCategoria", produto.Categoria);
            parametros.Add("vQtdEstoque", produto.Quantidade);
            parametros.Add("vIdUsuario", idUsu);

            // Pega o ID retornado do produto criado
            int idProduto = await conn.ExecuteScalarAsync<int>(
                "sp_CadastrarProduto",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return idProduto;
        }


        public async Task Alterar_e_DeletarProduto(Produto produto, string acaoAlterar, int idUsu)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();

            parametros.Add("vIdProduto", produto.IdProduto);
            parametros.Add("vNomeProduto", produto.NomeProduto);
            parametros.Add("vPreco", produto.Preco);
            parametros.Add("vDescricao", produto.Descricao);
            parametros.Add("vMarca", produto.Marca);
            parametros.Add("vAvaliacao", produto.Avaliacao);
            parametros.Add("vCategoria", produto.Categoria);
            parametros.Add("vQtd", produto.Quantidade);
            parametros.Add("vIdUsuario", idUsu);
            parametros.Add("vAcao", acaoAlterar);

            await conn.ExecuteAsync("sp_AlterarProduto", parametros, commandType: CommandType.StoredProcedure);
        }


        public async Task<Produto?> GetPorIdAsync(int id)
        {
            using var conn = new MySqlConnection(_connectionString);

            var parametros = new DynamicParameters();
            parametros.Add("vIdProduto", id);

            var rows = await conn.QueryAsync(
                "sp_ExibirProduto",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            var primeiroRegistro = rows.FirstOrDefault();
            if (primeiroRegistro == null)
                return null;

            var produto = new Produto
            {
                IdProduto = primeiroRegistro.IdProduto,
                NomeProduto = primeiroRegistro.NomeProduto,
                Descricao = primeiroRegistro.Descricao,
                Preco = primeiroRegistro.Preco,
                Marca = primeiroRegistro.Marca,
                Avaliacao = primeiroRegistro.Avaliacao,
                Disponibilidade = Convert.ToBoolean(primeiroRegistro.Disponibilidade),
                Quantidade = primeiroRegistro.QtdEstoque,
                Categoria = primeiroRegistro.Categoria,
                UrlImagens = rows.Select(r => (string)r.UrlImagem).Take(3).ToList()
            };

            return produto;
        }



        public async Task<IEnumerable<Produto>> GetTodosAsync()
        {
            using var conn = new MySqlConnection(_connectionString);

            var sql = @"SELECT * FROM vw_ExibirProdutos";

            var produtos = new Dictionary<int, Produto>();

            await conn.QueryAsync<Produto, string, Produto>(
                sql,
                (produto, urlImagem) =>
                {
                    if (!produtos.TryGetValue(produto.IdProduto, out var item))
                    {
                        produto.UrlImagens = new List<string>();
                        produtos.Add(produto.IdProduto, produto);
                        item = produto;
                    }

                    item.UrlImagens.Add(urlImagem);

                    return item;
                },
                splitOn: "UrlImagem"
            );

            return produtos.Values.ToList();
        }
    }
}