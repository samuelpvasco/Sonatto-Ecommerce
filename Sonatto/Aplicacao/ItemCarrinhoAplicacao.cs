using Sonatto.Aplicacao.Interfaces;
using Sonatto.Models;
using Sonatto.Repositorio.Interfaces;

namespace Sonatto.Aplicacao
{
    public class ItemCarrinhoAplicacao : IItemCarrinhoAplicacao
    {
        private readonly IItemCarrinhoRepositorio _itemCarrinhoRepositorio;

        public ItemCarrinhoAplicacao(IItemCarrinhoRepositorio itemCarrinhoRepositorio)
        {
            _itemCarrinhoRepositorio = itemCarrinhoRepositorio;
        }

        public async Task<int> AdicionarItemCarrinho(int idUsuario, int idProduto, int qtd)
        {
            return await _itemCarrinhoRepositorio.AdiconarItemCarrinho(idUsuario, idProduto, qtd);
        }

        public async Task AlterarQuantidade(int idCarrinho, int idProduto, int qtd)
        {
            await _itemCarrinhoRepositorio.AlterarQuantidade(idCarrinho, idProduto, qtd);
        }

        public async Task ApagarItemCarrinho(int idItem)
        {
            await _itemCarrinhoRepositorio.ApagarItemCarrinho(idItem);
        }

        public async Task<IEnumerable<ItemCarrinho>> BuscarItensCarrinho(int idCarrinho)
        {
            return await _itemCarrinhoRepositorio.BuscarItensCarrinho(idCarrinho);
        }
    }
}
