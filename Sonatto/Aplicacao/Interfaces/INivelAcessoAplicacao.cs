using Sonatto.Models;

namespace Sonatto.Aplicacao.Interfaces
{
    public interface INivelAcessoAplicacao
    {
        Task GerenciarNivel(int idUsuario, string acao, int IdNivel);
        Task<IEnumerable<NivelAcesso>> GetNiveisPorUsuario(int idUsuario);
        Task<IEnumerable<UsuariosNiveisViewModel>> GetTodosNiveis();
    }
}

