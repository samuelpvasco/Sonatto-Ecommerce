using Sonatto.Aplicacao.Interfaces;
using Sonatto.Aplicacao;
using Sonatto.Repositorio.Interfaces;
using Sonatto.Repositorio;

var builder = WebApplication.CreateBuilder(args);

// NECESSÁRIO PARA SESSION FUNCIONAR
builder.Services.AddDistributedMemoryCache();
builder.Services.AddControllersWithViews();
// SESSION
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Add services to the container.
builder.Services.AddControllersWithViews();

// PEGAR CONNECTION STRING
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// REPOSITÓRIOS 
builder.Services.AddScoped<IUsuarioRepositorio>(sp => new UsuarioRepositorio(connectionString));
builder.Services.AddScoped<IProdutoRepositorio>(sp => new ProdutoRepositorio(connectionString));
builder.Services.AddScoped<IVendaRepositorio>(sp => new VendaRepositorio(connectionString));
builder.Services.AddScoped<IItemVendaRepositorio>(sp => new ItemVendaRepositorio(connectionString));
builder.Services.AddScoped<IHistoricoAcaoRepositorio>(sp => new HistoricoAcaoRepositorio(connectionString));
builder.Services.AddScoped<ICarrinhoRepositorio>(sp => new CarrinhoRepositorio(connectionString));
builder.Services.AddScoped<IItemCarrinhoRepositorio>(sp => new ItemCarrinhoRepositorio(connectionString));
builder.Services.AddScoped<INivelAcessoRepositorio>(sp => new NivelAcessoRepositorio(connectionString));

// APLICAÇÕES 
builder.Services.AddScoped<IUsuarioAplicacao, UsuarioAplicacao>();
builder.Services.AddScoped<ILoginAplicacao, LoginAplicacao>();
builder.Services.AddScoped<IProdutoAplicacao, ProdutoAplicacao>();
builder.Services.AddScoped<IVendaAplicacao, VendaAplicacao>();
builder.Services.AddScoped<IItemVendaAplicacao, ItemVendaAplicacao>();
builder.Services.AddScoped<IHistoricoAcaoAplicacao, HistoricoAcaoAplicacao>();
builder.Services.AddScoped<ICarrinhoAplicacao, CarrinhoAplicacao>();
builder.Services.AddScoped<IItemCarrinhoAplicacao, ItemCarrinhoAplicacao>();
builder.Services.AddScoped<INivelAcessoAplicacao, NivelAcessoAplicacao>();

var app = builder.Build();

// configuração padrão
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

// SESSÃO ANTES DE AUTH
app.UseSession();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
