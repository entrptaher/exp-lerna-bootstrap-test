const puppeteer = require("puppeteer");
var Xvfb = require("xvfb");

(async () => {
  var xvfb = new Xvfb({
    displayNum: 101,
    xvfb_args: "-screen 0 1024x768x24".split(" ")
  });
  xvfb.startSync();
  const browser = await puppeteer.launch({
    headless: false,
    executablePath: process.env.CHROME_BIN || null,
    args: ["--no-sandbox"]
  });
  const page = await browser.newPage();
  await page.goto("https://example.com");
  const title = await page.title();
  await browser.close();
  console.log({ title });
  xvfb.stopSync();
})();
