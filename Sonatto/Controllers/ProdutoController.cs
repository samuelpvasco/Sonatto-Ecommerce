using Microsoft.AspNetCore.Mvc;
using Sonatto.Aplicacao;
using Sonatto.Aplicacao.Interfaces;
using Sonatto.Models;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using System;

namespace Sonatto.Controllers
{
    public class ProdutoController : Controller
    {
        private readonly IProdutoAplicacao _produtoAplicacao;
        private readonly IWebHostEnvironment _env;
        private readonly ILogger<ProdutoController> _logger;

        public ProdutoController(IProdutoAplicacao produtoAplicacao, IWebHostEnvironment env, ILogger<ProdutoController> logger)
        {
            _produtoAplicacao = produtoAplicacao;
            _env = env;
            _logger = logger;
        }


        // Buscar produtos na barra de pesquisa, categoria e paginação
        [HttpGet]
        public async Task<IActionResult> BuscarProdutos(string? search, string? categoria, decimal? minPreco, decimal? maxPreco, int pagina = 1)
        {
            int produtosPorPagina = 9;

            var todosProdutos = await _produtoAplicacao.GetTodosAsync();

            if (!string.IsNullOrWhiteSpace(search))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.NomeProduto != null &&
                                p.NomeProduto.StartsWith(search, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (!string.IsNullOrWhiteSpace(categoria))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Categoria != null &&
                                p.Categoria.Equals(categoria, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (minPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco >= minPreco.Value)
                    .ToList();
            }

            if (maxPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco <= maxPreco.Value)
                    .ToList();
            }

            var produtosPagina = todosProdutos
                .Skip((pagina - 1) * produtosPorPagina)
                .Take(produtosPorPagina)
                .ToList();

            ViewBag.PaginaAtual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling((double)todosProdutos.Count() / produtosPorPagina);
            ViewBag.Search = search;
            ViewBag.Categoria = categoria;
            ViewBag.MinPreco = minPreco;
            ViewBag.MaxPreco = maxPreco;

            // Retorna partial que inclui lista + paginação
            return PartialView("_ListaProdutosParcial", produtosPagina);
        }


        // Buscar todos os produtos para o catálogo
        public async Task<IActionResult> Catalogo(string search, string categoria, int pagina = 1, decimal? minPreco = null, decimal? maxPreco = null)
        {
            int produtosPorPagina = 9;

            var todosProdutos = await _produtoAplicacao.GetTodosAsync();

            if (!string.IsNullOrWhiteSpace(search))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.NomeProduto != null &&
                                p.NomeProduto.StartsWith(search, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (!string.IsNullOrWhiteSpace(categoria))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Categoria != null &&
                                p.Categoria.Equals(categoria, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (minPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco >= minPreco.Value)
                    .ToList();
            }

            if (maxPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco <= maxPreco.Value)
                    .ToList();
            }

            var produtos = todosProdutos
                .Skip((pagina - 1) * produtosPorPagina)
                .Take(produtosPorPagina)
                .ToList();

            ViewBag.PaginaAtual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling((double)todosProdutos.Count() / produtosPorPagina);

            ViewBag.Search = search;
            ViewBag.Categoria = categoria;
            ViewBag.MinPreco = minPreco;
            ViewBag.MaxPreco = maxPreco;

            return View(produtos);
        }


        public class ComboDeView
        {
            public Produto Produto { get; set; }
            public List<Produto> Produtos { get; set; }
        }

        public async Task<IActionResult> Produto(int id)
        {
            var produto = await _produtoAplicacao.GetPorIdAsync(id);
            var produtos = await _produtoAplicacao.GetTodosAsync();

            var visualizador = new ComboDeView
            {
                Produto = produto,
                Produtos = (List<Produto>)produtos
            };

            if (produto == null)
                return NotFound();

            return View(visualizador);
        }


        // Tela de Cadastro de Produto
        public IActionResult Adicionar()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Adicionar(Produto produto, List<string> imagens)
        {
            int? idUsu = HttpContext.Session.GetInt32("UserId");
            if (idUsu == null)
                return RedirectToAction("Index", "Login");

            if (!ModelState.IsValid)
                return View(produto);

            try
            {
                // Adiciona o produto
                int idProduto = await _produtoAplicacao.AdicionarProduto(produto, idUsu.Value);

                // Apenas salva as URLs recebidas
                if (imagens != null && imagens.Count > 0)
                {
                    foreach (var url in imagens)
                    {
                        if (string.IsNullOrWhiteSpace(url)) continue;

                        await _produtoAplicacao.AdicionarImagens(idProduto, url);
                    }
                }

                return RedirectToAction("Produto", new { id = idProduto });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao cadastrar produto");
                TempData["Erro"] = ex.ToString();
                return View(produto);
            }
        }




        // GET: Editar — agora retorna ComboDeView para que a view de edição mostre o catálogo lateral
        [HttpGet]
        public async Task<IActionResult> Editar(int? id)
        {
            if (!id.HasValue)
            {

                return RedirectToAction(nameof(CatalogoEditar));
            }

            var produto = await _produtoAplicacao.GetPorIdAsync(id.Value);
            if (produto == null)
                return NotFound();


            return View(produto);
        }


        public async Task<IActionResult> CatalogoEditar(string search, string categoria, int pagina = 1, decimal? minPreco = null, decimal? maxPreco = null)
        {
            int produtosPorPagina = 12;
            var todosProdutos = await _produtoAplicacao.GetTodosAsync();

            if (!string.IsNullOrWhiteSpace(search))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.NomeProduto != null &&
                                p.NomeProduto.StartsWith(search, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (!string.IsNullOrWhiteSpace(categoria))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Categoria != null &&
                                p.Categoria.Equals(categoria, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (minPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco >= minPreco.Value)
                    .ToList();
            }

            if (maxPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco <= maxPreco.Value)
                    .ToList();
            }

            var produtos = todosProdutos
                .Skip((pagina - 1) * produtosPorPagina)
                .Take(produtosPorPagina)
                .ToList();

            ViewBag.PaginaAtual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling((double)todosProdutos.Count() / produtosPorPagina);
            ViewBag.Search = search;
            ViewBag.Categoria = categoria;
            ViewBag.MinPreco = minPreco;
            ViewBag.MaxPreco = maxPreco;

            return View("CatalogoEditar", produtos);
        }


        // POST: EDITA PRODUTO
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ActionName("Editar")]
        public async Task<IActionResult> EditarPost(Produto produto)
        {
            int? idUsu = HttpContext.Session.GetInt32("UserId");
            if (idUsu == null)
                return RedirectToAction("Index", "Login");

            if (!ModelState.IsValid)
            {
                // retorna para a view de edição exibindo validações
                return View(produto);
            }

            try
            {
                // Apenas atualiza os dados básicos do produto (nome, marca, preço, etc.)
                await _produtoAplicacao.Alterar_e_DeletarProduto(produto, "alterar", idUsu.Value);

                TempData["Sucesso"] = "Produto alterado com sucesso!";
                return RedirectToAction("Produto", new { id = produto.IdProduto });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao alterar produto id {Id}", produto?.IdProduto);
                TempData["Erro"] = "Erro ao salvar alterações.";
                return View(produto);
            }
        }


        // DELETAR PRODUTO
        public async Task<IActionResult> Deletar(int id)
        {
            var produto = await _produtoAplicacao.GetPorIdAsync(id);

            if (produto == null)
                return NotFound();

            return View(produto);
        }


        // POST: Confirmação da exclusão do produto
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeletarConfirm(int id)
        {
            int? idUsu = HttpContext.Session.GetInt32("UserId");
            if (idUsu == null)
                return RedirectToAction("Index", "Login");

            var produto = await _produtoAplicacao.GetPorIdAsync(id);
            if (produto == null)
                return NotFound();

            // Use the existing app method to perform delete (action string "DELETAR")
            await _produtoAplicacao.Alterar_e_DeletarProduto(produto, "deletar", idUsu.Value);

            TempData["Sucesso"] = "Produto deletado com sucesso.";
            // Redirect back to the selection catalog
            return RedirectToAction(nameof(Catalogo));
        }


        // Upload para pasta temporária do sistema e retorna URL para servir
        [HttpPost]
        public async Task<IActionResult> UploadImagem(IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest(new { error = "Arquivo não enviado." });

            if (!file.ContentType.StartsWith("image/"))
                return BadRequest(new { error = "Apenas imagens são permitidas." });

            const long MAX_BYTES = 5 * 1024 * 1024; // 5 MB
            if (file.Length > MAX_BYTES)
                return BadRequest(new { error = "Arquivo muito grande (máx 5MB)." });

            var tempDir = Path.Combine(Path.GetTempPath(), "sonatto_uploads");
            Directory.CreateDirectory(tempDir);

            var ext = Path.GetExtension(file.FileName);
            if (string.IsNullOrEmpty(ext)) ext = ".jpg";
            var fileName = $"{Guid.NewGuid()}{ext}";
            var filePath = Path.Combine(tempDir, fileName);

            await using (var fs = System.IO.File.Create(filePath))
            {
                await file.CopyToAsync(fs);
            }

            var url = Url.Action("ServeTempImage", "Produto", new { name = fileName });
            return Json(new { url });
        }

        [HttpGet]
        public IActionResult ServeTempImage(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return NotFound();

            var tempDir = Path.Combine(Path.GetTempPath(), "sonatto_uploads");
            var filePath = Path.Combine(tempDir, name);

            if (!System.IO.File.Exists(filePath)) return NotFound();

            var ext = Path.GetExtension(filePath).ToLowerInvariant();
            var contentType = ext switch
            {
                ".png" => "image/png",
                ".jpg" or ".jpeg" => "image/jpeg",
                ".gif" => "image/gif",
                _ => "application/octet-stream",
            };

            return PhysicalFile(filePath, contentType);
        }

        public async Task<IActionResult> CatalogoDeletar(string search, string categoria, int pagina = 1, decimal? minPreco = null, decimal? maxPreco = null)
        {
            int produtosPorPagina = 12;
            var todosProdutos = await _produtoAplicacao.GetTodosAsync();

            if (!string.IsNullOrWhiteSpace(search))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.NomeProduto != null &&
                                p.NomeProduto.StartsWith(search, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (!string.IsNullOrWhiteSpace(categoria))
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Categoria != null &&
                                p.Categoria.Equals(categoria, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            if (minPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco >= minPreco.Value)
                    .ToList();
            }

            if (maxPreco.HasValue)
            {
                todosProdutos = todosProdutos
                    .Where(p => p.Preco <= maxPreco.Value)
                    .ToList();
            }

            var produtos = todosProdutos
                .Skip((pagina - 1) * produtosPorPagina)
                .Take(produtosPorPagina)
                .ToList();

            ViewBag.PaginaAtual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling((double)todosProdutos.Count() / produtosPorPagina);
            ViewBag.Search = search;
            ViewBag.Categoria = categoria;
            ViewBag.MinPreco = minPreco;
            ViewBag.MaxPreco = maxPreco;

            return View("CatalogoDeletar", produtos);
        }
    }
}