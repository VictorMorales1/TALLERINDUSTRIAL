using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CapaEntidad;
using FontAwesome.Sharp;
using CapaNegocio;

namespace CapaPresentacion
{
    public partial class Inicio : Form
    {
        private static Usuario usuarioActual;
        private static IconMenuItem MenuActivo = null;
        private static Form FormularioActivo = null;
        public Inicio(Usuario objusuario)
        {
            usuarioActual = objusuario;

            InitializeComponent();
        }

        private void Inicio_Load(object sender, EventArgs e)
        {
            List<Permiso> ListaPermisos = new CN_Permiso().Listar(usuarioActual.IdUsuario);

            foreach (IconMenuItem iconMenu in menu.Items)
            {
                bool encontrado = ListaPermisos.Any(m => m.NombreMenu == iconMenu.Name);

                if (encontrado == false)
                {
                    iconMenu.Visible = false; 
                }
            }



            lblusuario.Text = usuarioActual.NombreCompleto;
        }

        private void menustock_Click(object sender, EventArgs e)
        {

        }

        private void Abrirformulario(IconMenuItem menu, Form formulario)
        {
            if(MenuActivo != null)
            {
                MenuActivo.BackColor = Color.White;
            }

            menu.BackColor = Color.Silver;
            MenuActivo = menu;

            if (FormularioActivo != null)
            {
                FormularioActivo.Close();
            }

            FormularioActivo = formulario;
            formulario.TopLevel = false;
            formulario.FormBorderStyle = FormBorderStyle.None;
            formulario.Dock = DockStyle.Fill;
            formulario.BackColor = Color.SteelBlue;

            Contenedor.Controls.Add(formulario);
            formulario.Show();

        }
        private void menuusuario_Click(object sender, EventArgs e)
        {
            Abrirformulario((IconMenuItem)sender, new frmusuarios());
        }

        private void submenucategoria_Click(object sender, EventArgs e)
        {
            Abrirformulario(menustock, new frmCategorias());
        }

        private void submenuproducto_Click(object sender, EventArgs e)
        {
            Abrirformulario(menustock, new frmProducto());
        }

        private void submenuresgistrarventa_Click(object sender, EventArgs e)
        {
            Abrirformulario(menuventas, new frmVentas());
        }

        private void submenuverdetalleventa_Click(object sender, EventArgs e)
        {
            Abrirformulario(menuventas, new frmDetalleVenta());
        }

        private void submenuregistrarcompra_Click(object sender, EventArgs e)
        {
            Abrirformulario(menucompras, new frmCompras(usuarioActual));

        }

        private void submenuverdetallecompra_Click(object sender, EventArgs e)
        {
            Abrirformulario(menucompras, new frmDetalleCompra());

        }

        private void menuclientes_Click(object sender, EventArgs e)
        {
            Abrirformulario((IconMenuItem)sender, new frmClientes());
        }

        private void menuproveedores_Click(object sender, EventArgs e)
        {
            Abrirformulario((IconMenuItem)sender, new frmProveedores());
        }

        private void menureportes_Click(object sender, EventArgs e)
        {
            Abrirformulario((IconMenuItem)sender, new frmReportes());
        }
    }
}
