module.exports = function (eleventyConfig) {
  const pathPrefix = process.env.GITHUB_PAGES ? "/site" : "";
  eleventyConfig.addGlobalData("pathPrefix", pathPrefix);

  eleventyConfig.addPassthroughCopy("assets");
  eleventyConfig.addPassthroughCopy("content/**/*.png");
  eleventyConfig.addPassthroughCopy("content/**/*.jpg");
  eleventyConfig.addPassthroughCopy("content/**/*.webp");

  return {
    dir: {
      input: "content",
      includes: "../_includes",
      data: "../_data",
      output: "_site",
    },
    pathPrefix: pathPrefix ? pathPrefix + "/" : "",
  };
};
