namespace Sonatto.Models
{
    public class ItemCarrinho
    {
        public int IdItemCarrinho { get; set; }
        public int IdCarrinho { get; set; }
        public int IdProduto { get; set; }
        public int QtdItemCar { get; set; }
        public decimal PrecoUnidadeCar { get; set; }
        public decimal SubTotal { get; set; }
        public string? ProdutoNome { get; set; }
        public string? ProdutoImagemUrl { get; set; }
    }
}
