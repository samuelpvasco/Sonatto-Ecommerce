using Sonatto.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Sonatto.Repositorio.Interfaces
{
    public interface INivelAcessoRepositorio
    {
        Task GerenciarNivel(int idUsuario, string acao ,int IdNivel);
        Task<IEnumerable<NivelAcesso>> GetNiveisPorUsuario(int idUsuario);
        Task<IEnumerable<UsuariosNiveisViewModel>> GetTodosNiveis();
    }
}
