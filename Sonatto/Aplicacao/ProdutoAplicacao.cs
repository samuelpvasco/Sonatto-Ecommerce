using Sonatto.Aplicacao.Interfaces;
using Sonatto.Models;
using Sonatto.Repositorio.Interfaces;

namespace Sonatto.Aplicacao
{
    public class ProdutoAplicacao : IProdutoAplicacao

    {
        private readonly IProdutoRepositorio _produtoRepositorio;

        public ProdutoAplicacao(IProdutoRepositorio produtoRepositorio)
        {
            _produtoRepositorio = produtoRepositorio;
        }

        public async Task AdicionarImagens(int idProduto, string url)
        {
            await _produtoRepositorio.AdicionarImagens(idProduto, url);
        }


        public async  Task<int> AdicionarProduto(Produto produto, int idUsu)
        {
           return await _produtoRepositorio.AdicionarProduto(produto, idUsu);
        }

        public async Task Alterar_e_DeletarProduto(Produto produto, string acaoAlterar, int idUsu)
        {
            await _produtoRepositorio.Alterar_e_DeletarProduto(produto, acaoAlterar, idUsu);
        }

        public async Task<Produto?> GetPorIdAsync(int id)
        {
            var produtoBuscado = await _produtoRepositorio.GetPorIdAsync(id);
            return produtoBuscado;
        }

        public async Task<IEnumerable<Produto>> GetTodosAsync()
        {
            var produtos = await _produtoRepositorio.GetTodosAsync();
            return produtos;
        }
    }
}
