using Sonatto.Models;

using Sonatto.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Sonatto.Aplicacao.Interfaces
{
    public interface IProdutoAplicacao
    {
        Task<IEnumerable<Produto>> GetTodosAsync();
        Task<Produto?> GetPorIdAsync(int id);
        Task AdicionarImagens(int idProduto, string url);
        Task<int> AdicionarProduto(Produto produto, int idUsu);
        Task Alterar_e_DeletarProduto(Produto produto, string acaoAlterar, int idUsu);
    }
}
