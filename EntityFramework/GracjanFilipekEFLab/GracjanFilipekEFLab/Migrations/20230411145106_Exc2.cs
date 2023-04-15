using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GracjanFilipekEFLab.Migrations
{
    /// <inheritdoc />
    public partial class Exc2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Products_Suppliers_SuppliedBySupplierID",
                table: "Products");

            migrationBuilder.DropIndex(
                name: "IX_Products_SuppliedBySupplierID",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "SuppliedBySupplierID",
                table: "Products");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SuppliedBySupplierID",
                table: "Products",
                type: "INTEGER",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Products_SuppliedBySupplierID",
                table: "Products",
                column: "SuppliedBySupplierID");

            migrationBuilder.AddForeignKey(
                name: "FK_Products_Suppliers_SuppliedBySupplierID",
                table: "Products",
                column: "SuppliedBySupplierID",
                principalTable: "Suppliers",
                principalColumn: "SupplierID");
        }
    }
}
