using Sonatto.Models;

namespace Sonatto.Aplicacao.Interfaces
{
    public interface IUsuarioAplicacao
    {
        Task<int> CadastrarUsuarioAsync(Usuario usuario);

        Task AlterarUsuarioAsync(Usuario usuario);

        Task<Usuario?> ObterPorIdAsync(int idUsuario);

        Task<Usuario?> ObterPorEmailAsync(string email);

        Task<Usuario?> ObterPorEmailSenhaAsync(string email, string senha);


        
    }
}
