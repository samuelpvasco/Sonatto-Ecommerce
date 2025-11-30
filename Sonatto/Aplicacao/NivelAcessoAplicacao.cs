using Sonatto.Aplicacao.Interfaces;
using Sonatto.Models;

namespace Sonatto.Aplicacao
{
    public class NivelAcessoAplicacao : INivelAcessoAplicacao
    {
        private readonly Repositorio.Interfaces.INivelAcessoRepositorio _nivelAcessoRepositorio;
        public NivelAcessoAplicacao(Repositorio.Interfaces.INivelAcessoRepositorio nivelAcessoRepositorio)
        {
            _nivelAcessoRepositorio = nivelAcessoRepositorio;
        }
        public async Task GerenciarNivel(int idUsuario, string acao, int IdNivel)
        {
            await _nivelAcessoRepositorio.GerenciarNivel(idUsuario, acao, IdNivel);
        }
        public async Task<IEnumerable<NivelAcesso>> GetNiveisPorUsuario(int idUsuario)
        {
            return await _nivelAcessoRepositorio.GetNiveisPorUsuario(idUsuario);
        }

        public async Task<IEnumerable<UsuariosNiveisViewModel>> GetTodosNiveis()
        {
            return await _nivelAcessoRepositorio.GetTodosNiveis();
        }
    }
}
