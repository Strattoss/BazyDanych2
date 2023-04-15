using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GracjanFilipekEFLab.Migrations
{
    /// <inheritdoc />
    public partial class Exc5_3_2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Customers_Companies_CompanyName",
                table: "Customers");

            migrationBuilder.DropForeignKey(
                name: "FK_Suppliers_Companies_CompanyName",
                table: "Suppliers");

            migrationBuilder.AddColumn<string>(
                name: "City",
                table: "Suppliers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Street",
                table: "Suppliers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ZipCode",
                table: "Suppliers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "City",
                table: "Customers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Street",
                table: "Customers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ZipCode",
                table: "Customers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "City",
                table: "Suppliers");

            migrationBuilder.DropColumn(
                name: "Street",
                table: "Suppliers");

            migrationBuilder.DropColumn(
                name: "ZipCode",
                table: "Suppliers");

            migrationBuilder.DropColumn(
                name: "City",
                table: "Customers");

            migrationBuilder.DropColumn(
                name: "Street",
                table: "Customers");

            migrationBuilder.DropColumn(
                name: "ZipCode",
                table: "Customers");

            migrationBuilder.AddForeignKey(
                name: "FK_Customers_Companies_CompanyName",
                table: "Customers",
                column: "CompanyName",
                principalTable: "Companies",
                principalColumn: "CompanyName",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Suppliers_Companies_CompanyName",
                table: "Suppliers",
                column: "CompanyName",
                principalTable: "Companies",
                principalColumn: "CompanyName",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
