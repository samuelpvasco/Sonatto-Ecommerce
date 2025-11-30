using Sonatto.Models;

namespace Sonatto.Aplicacao.Interfaces
{
    public interface IItemCarrinhoAplicacao
    {
        Task AlterarQuantidade(int idCarrinho, int idProduto, int qtd);
        Task ApagarItemCarrinho(int idItem);
        Task<int> AdicionarItemCarrinho(int idUsuario, int idProduto, int qtd);
        Task<IEnumerable<ItemCarrinho>> BuscarItensCarrinho(int idCarrinho);
    }
}
