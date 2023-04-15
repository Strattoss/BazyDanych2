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
    [Migration("20230412142554_Exc5_1_1")]
    partial class Exc5_1_1
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

                    b.Property<string>("Discriminator")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("Street")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("ZipCode")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.HasKey("CompanyName");

                    b.ToTable("Companies");

                    b.HasDiscriminator<string>("Discriminator").HasValue("Company");

                    b.UseTphMappingStrategy();
                });

            modelBuilder.Entity("GracjanFilipekEFLab.Customer", b =>
                {
                    b.HasBaseType("GracjanFilipekEFLab.Company");

                    b.Property<float>("Discount")
                        .HasColumnType("REAL");

                    b.HasDiscriminator().HasValue("Customer");
                });

            modelBuilder.Entity("GracjanFilipekEFLab.Supplier", b =>
                {
                    b.HasBaseType("GracjanFilipekEFLab.Company");

                    b.Property<string>("BankAccountNumber")
                        .IsRequired()
                        .HasMaxLength(20)
                        .HasColumnType("TEXT");

                    b.HasDiscriminator().HasValue("Supplier");
                });
#pragma warning restore 612, 618
        }
    }
}