namespace Sonatto.Models
{
    public class Usuario
    {
        public int IdUsuario { get; set; }
        public required string Nome { get; set; }
        public required string Email { get; set; }
        public required string Senha { get; set; }
        public required string CPF { get; set; }
        public required string Endereco { get; set; }
        public required string Telefone { get; set; }
    }
}
