using Microsoft.AspNetCore.Mvc;
using Sonatto.Aplicacao.Interfaces;

namespace Sonatto.Controllers
{
    public class VendaController : Controller
    {
        private readonly IVendaAplicacao _vendaAplicacao;
        private readonly ICarrinhoAplicacao _carrinhoAplicacao;
        private readonly IItemCarrinhoAplicacao _itemCarrinhoAplicacao;
        private readonly IProdutoAplicacao _produtoAplicacao;

        public VendaController(IVendaAplicacao vendaAplicacao, ICarrinhoAplicacao carrinhoAplicacao, IItemCarrinhoAplicacao itemCarrinhoAplicacao, IProdutoAplicacao produtoAplicacao)
        {
            _vendaAplicacao = vendaAplicacao;
            _carrinhoAplicacao = carrinhoAplicacao;
            _itemCarrinhoAplicacao = itemCarrinhoAplicacao;
            _produtoAplicacao = produtoAplicacao;
        }

        // GET: /Venda/Buscar?idUsuario=5
        [HttpGet]
        public async Task<IActionResult> Buscar(int idUsuario)
        {
            try
            {
                if (idUsuario <= 0)
                    return Json(new { sucesso = false, mensagem = "IdUsuario inválido." });

                var venda = await _vendaAplicacao.BuscarVendas(idUsuario);

                return Json(new { sucesso = true, dados = venda });
            }
            catch (Exception ex)
            {
                return Json(new { sucesso = false, mensagem = $"Erro ao buscar venda: {ex.Message}" });
            }
        }

        // POST: /Venda/Gerar
        [HttpPost]
        public async Task<IActionResult> Gerar(int idUsuario, string tipoPag, int idCarrinho)
        {
            try
            {
                if (idUsuario <= 0 || idCarrinho <= 0)
                    return Json(new { sucesso = false, mensagem = "Dados inválidos para gerar venda." });

                // Verificar disponibilidade de estoque para cada item do carrinho antes de gerar a venda
                try
                {
                    var itens = (await _itemCarrinhoAplicacao.BuscarItensCarrinho(idCarrinho)).ToList();
                    foreach (var it in itens)
                    {
                        var produto = await _produtoAplicacao.GetPorIdAsync(it.IdProduto);
                        if (produto == null)
                        {
                            return Json(new { sucesso = false, mensagem = $"Produto (id {it.IdProduto}) não encontrado." });
                        }

                        // se quantidade solicitada for maior que a disponível, bloquear a venda
                        if (it.QtdItemCar > produto.Quantidade)
                        {
                            return Json(new { sucesso = false, mensagem = $"Quantidade insuficiente para '{produto.NomeProduto}'. Disponível: {produto.Quantidade}, solicitado: {it.QtdItemCar}." });
                        }
                    }
                }
                catch (Exception ex)
                {
                    return Json(new { sucesso = false, mensagem = $"Erro ao verificar estoque: {ex.Message}" });
                }

                await _vendaAplicacao.GerarVenda(idUsuario, tipoPag, idCarrinho);

                // após gerar a venda, desativa o carrinho para que não seja mais retornado como disponível
                await _carrinhoAplicacao.DesativarCarrinho(idCarrinho);

                return Json(new { sucesso = true, mensagem = "Venda gerada com sucesso!" });
            }
            catch (Exception ex)
            {
                return Json(new { sucesso = false, mensagem = $"Erro ao gerar venda: {ex.Message}" });
            }
        }
    }
}
