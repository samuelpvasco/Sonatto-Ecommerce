using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sonatto.Models
{
    public class Produto
    {
        public int IdProduto { get; set; }

        [Required(ErrorMessage = "O nome do produto é obrigatório.")]
        [StringLength(100)]
        public required string NomeProduto { get; set; }

        [Required(ErrorMessage = "A descrição é obrigatória.")]
        [StringLength(500)]
        public required string Descricao { get; set; }

        [Required(ErrorMessage = "O preço é obrigatório.")]
        [Column(TypeName = "decimal(18,2)")]
        [Range(0.01, double.MaxValue, ErrorMessage = "O preço deve ser maior que zero.")]
        public required decimal Preco { get; set; }

        [StringLength(50)]
        [Required(ErrorMessage = "A categoria do produto é obrigatória.")]
        public required string Categoria { get; set; }

        [Required(ErrorMessage = "A marca do produto é obrigatória.")]
        [StringLength(100)]
        public required string Marca { get; set; }

        public required int Quantidade { get; set; }

        [Required(ErrorMessage = "A avaliação é obrigatória.")]
        [Column(TypeName = "decimal(2,1)")]
        public required decimal Avaliacao { get; set; }
        
        [Required(ErrorMessage = "A avaliação é obrigatória.")]
        public required bool Disponibilidade { get; set; }

        public List<string> UrlImagens { get; set; } = new List<string>();
    }
}
