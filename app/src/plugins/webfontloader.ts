export async function loadFonts() {
  const webFontLoader = await import("webfontloader");

  webFontLoader.load({
    google: {
      families: [
        "Roboto:100,300,400,500,700,900&display=swap",
        "Manrope:200,300,400,500,600,700,800&display=swap",
        "PT Sans:400,700&display=swap",
      ],
    },
  });
}
