using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;
namespace CapaNegocio
{
    public class CN_Proveedor
    {
        private CD_proveedor objcd_Proveedor = new CD_proveedor();

        public List<Proveedor> Listar()
        {
            return objcd_Proveedor.Listar();
        }

        public int Registrar(Proveedor obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (obj.RazonSocial == "")
            {
                Mensaje += "Es necesario la Razon Social del Proveedor\n";
            }

            if (obj.Documento == "")
            {
                Mensaje += "Es necesario el Documento del Proveedor\n";
            }
            if (obj.Correo == "")
            {
                Mensaje += "Es necesaria la Correo del Proveedor\n";
            }

            if (Mensaje != string.Empty)
            {
                return 0;
            }
            else
            {
                return objcd_Proveedor.Registrar(obj, out Mensaje);
            }
        }

        public bool Editar(Proveedor obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (obj.RazonSocial == "")
            {
                Mensaje += "Es necesario la Razon Social del Proveedor\n";
            }

            if (obj.Documento == "")
            {
                Mensaje += "Es necesario el Documento del Proveedor\n";
            }
            if (obj.Correo == "")
            {
                Mensaje += "Es necesaria la Correo del Proveedor\n";
            }

            if (Mensaje != string.Empty)
            {
                return false;
            }
            else
            {
                return objcd_Proveedor.Editar(obj, out Mensaje);
            }

        }

        public bool Eliminar(Proveedor obj, out string Mensaje)
        {
            return objcd_Proveedor.Eliminar(obj, out Mensaje);
        }
    }
}
