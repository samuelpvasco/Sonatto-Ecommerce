using Microsoft.AspNetCore.Mvc;
using Sonatto.Aplicacao.Interfaces;

namespace Sonatto.Controllers
{
    public class ItemCarrinhoController : Controller
    {
        private readonly IItemCarrinhoAplicacao _itemCarrinhoAplicacao;
        private readonly IProdutoAplicacao _produtoAplicacao;

        public ItemCarrinhoController(IItemCarrinhoAplicacao itemCarrinhoAplicacao, IProdutoAplicacao produtoAplicacao)
        {
            _itemCarrinhoAplicacao = itemCarrinhoAplicacao;
            _produtoAplicacao = produtoAplicacao;
        }


        [HttpPost]
        public async Task<IActionResult> Adicionar(int idUsuario, int idProduto, int qtd)
        {
            try
            {
                // se idUsuario não foi enviado pelo cliente, tenta obter da sessão
                if (idUsuario <= 0)
                {
                    idUsuario = HttpContext.Session.GetInt32("UserId") ?? 0;
                }

                if (idUsuario <= 0)
                {
                    return Json(new
                    {
                        sucesso = false,
                        mensagem = "Usuário não autenticado. Faça login para adicionar ao carrinho."
                    });
                }

                // valida estoque do produto
                var produto = await _produtoAplicacao.GetPorIdAsync(idProduto);
                if (produto == null)
                {
                    return Json(new { sucesso = false, mensagem = "Produto não encontrado." });
                }
                if (produto.Quantidade <= 0)
                {
                    return Json(new { sucesso = false, mensagem = "Produto sem estoque." });
                }
                if (qtd > produto.Quantidade)
                {
                    qtd = produto.Quantidade; // força limite
                }

                await _itemCarrinhoAplicacao.AdicionarItemCarrinho(idUsuario, idProduto, qtd);

                return Json(new
                {
                    sucesso = true,
                    mensagem = "Item adicionado ao carrinho com sucesso!",
                    idUsuario = idUsuario
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    sucesso = false,
                    mensagem = "Erro ao adicionar item.",
                    erro = ex.Message
                });
            }
        }

        [HttpPost]
        public async Task<IActionResult> AlterarQuantidade(int idCarrinho, int idProduto, int qtd)
        {
            try
            {
                var produto = await _produtoAplicacao.GetPorIdAsync(idProduto);
                if (produto == null)
                {
                    return Json(new { sucesso = false, mensagem = "Produto não encontrado." });
                }
                if (produto.Quantidade <= 0)
                {
                    return Json(new { sucesso = false, mensagem = "Produto sem estoque." });
                }
                if (qtd > produto.Quantidade)
                {
                    qtd = produto.Quantidade; // clamp
                }
                if (qtd < 1)
                {
                    qtd = 1;
                }

                await _itemCarrinhoAplicacao.AlterarQuantidade(idCarrinho, idProduto, qtd);

                return Json(new
                {
                    sucesso = true,
                    mensagem = "Quantidade alterada!"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    sucesso = false,
                    mensagem = "Erro ao alterar quantidade.",
                    erro = ex.Message
                });
            }
        }


        [HttpPost]
        public async Task<IActionResult> Remover(int idItemCarrinho)
        {
            try
            {
                await _itemCarrinhoAplicacao.ApagarItemCarrinho(idItemCarrinho);

                return Json(new
                {
                    sucesso = true,
                    mensagem = "Item removido do carrinho!"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    sucesso = false,
                    mensagem = "Erro ao remover item.",
                    erro = ex.Message
                });
            }
        }

 
        [HttpGet]
        public async Task<IActionResult> Listar(int idCarrinho)
        {
            try
            {
                var itens = await _itemCarrinhoAplicacao.BuscarItensCarrinho(idCarrinho);

                return Json(new
                {
                    sucesso = true,
                    itens
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    sucesso = false,
                    mensagem = "Erro ao buscar itens.",
                    erro = ex.Message
                });
            }
        }
    }
}
