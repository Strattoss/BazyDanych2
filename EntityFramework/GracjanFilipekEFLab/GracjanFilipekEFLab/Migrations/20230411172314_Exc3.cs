﻿using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GracjanFilipekEFLab.Migrations
{
    /// <inheritdoc />
    public partial class Exc3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Products_Suppliers_SupplierID",
                table: "Products");

            migrationBuilder.DropIndex(
                name: "IX_Products_SupplierID",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "SupplierID",
                table: "Products");

            migrationBuilder.AddColumn<int>(
                name: "SuppliedBySupplierID",
                table: "Products",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Products_SuppliedBySupplierID",
                table: "Products",
                column: "SuppliedBySupplierID");

            migrationBuilder.AddForeignKey(
                name: "FK_Products_Suppliers_SuppliedBySupplierID",
                table: "Products",
                column: "SuppliedBySupplierID",
                principalTable: "Suppliers",
                principalColumn: "SupplierID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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

            migrationBuilder.AddColumn<int>(
                name: "SupplierID",
                table: "Products",
                type: "INTEGER",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Products_SupplierID",
                table: "Products",
                column: "SupplierID");

            migrationBuilder.AddForeignKey(
                name: "FK_Products_Suppliers_SupplierID",
                table: "Products",
                column: "SupplierID",
                principalTable: "Suppliers",
                principalColumn: "SupplierID");
        }
    }
}
