using System.ComponentModel.DataAnnotations;

namespace Sonatto.Models
{
    public class Venda
    {
        public int IdVenda { get; set; }
        public int IdUsuario { get; set; }
        [Required(ErrorMessage = "O tipo de pagamento é obrigatório.")]
        public required string TipoPag { get; set; }
        public decimal ValorTotal { get; set; }
        public DateTime DataVenda { get; set; }
        


    }
}
