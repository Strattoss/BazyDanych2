﻿// <auto-generated />
using GracjanFilipekEFLab;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace GracjanFilipekEFLab.Migrations
{
    [DbContext(typeof(ProductContext))]
    [Migration("20230412163411_Exc4_3")]
    partial class Exc4_3
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder.HasAnnotation("ProductVersion", "7.0.4");

            modelBuilder.Entity("GracjanFilipekEFLab.Company", b =>
                {
                    b.Property<string>("CompanyName")
                        .HasColumnType("TEXT");

                    b.Property<string>("City")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("Street")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("ZipCode")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.HasKey("CompanyName");

                    b.ToTable("Company");

                    b.UseTpcMappingStrategy();
                });

            modelBuilder.Entity("GracjanFilipekEFLab.Invoice", b =>
                {
                    b.Property<int>("InvoiceNumber")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.HasKey("InvoiceNumber");

                    b.ToTable("Invoices");
                });

            modelBuilder.Entity("GracjanFilipekEFLab.InvoiceProduct", b =>
                {
                    b.Property<int>("InvoiceId")
                        .HasColumnType("INTEGER");

                    b.Property<int>("ProductId")
                        .HasColumnType("INTEGER");

                    b.Property<int>("Quantity")
                        .HasColumnType("INTEGER");

                    b.HasKey("InvoiceId", "ProductId");

                    b.HasIndex("ProductId");

                    b.ToTable("InvoicesProduct");
                });

            modelBuilder.Entity("GracjanFilipekEFLab.Product", b =>
                {
                    b.Property<int>("ProductID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("ProductName")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<int>("UnitsOnStock")
                        .HasColumnType("INTEGER");

                    b.HasKey("ProductID");

                    b.ToTable("Products");
                });

            modelBuilder.Entity("GracjanFilipekEFLab.InvoiceProduct", b =>
                {
                    b.HasOne("GracjanFilipekEFLab.Invoice", "Invoice")
                        .WithMany("InvoiceProducts")
                        .HasForeignKey("InvoiceId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GracjanFilipekEFLab.Product", "Product")
                        .WithMany("InvoiceProducts")
                        .HasForeignKey("ProductId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Invoice");

                    b.Navigation("Product");
                });

            modelBuilder.Entity("GracjanFilipekEFLab.Invoice", b =>
                {
                    b.Navigation("InvoiceProducts");
                });

            modelBuilder.Entity("GracjanFilipekEFLab.Product", b =>
                {
                    b.Navigation("InvoiceProducts");
                });
#pragma warning restore 612, 618
        }
    }
}
