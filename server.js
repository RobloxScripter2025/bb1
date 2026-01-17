import express from "express";
import puppeteer from "puppeteer";

const app = express();
app.use(express.json());
app.use(express.static("public"));

app.post("/join", async (req, res) => {
  const { gameId, name } = req.body;
  if (!gameId || !name) return res.status(400).json({ error: "Missing gameId or name" });

  try {
    const browser = await puppeteer.launch({
      headless: true,
      executablePath: "/usr/bin/google-chrome-stable", // system Chrome
      args: ["--no-sandbox", "--disable-setuid-sandbox"]
    });

    const page = await browser.newPage();
    await page.goto("https://blooketbot.com");

    // Example: fill out game join form
    await page.type("#gcode", gameId);
    await page.type("#gname", name);
       await page.evaluate(() => {
      const btn = document.querySelector(".joinButton");
      if (btn) btn.click();
    });

    await browser.close();
    res.json({ success: true, message: `Joined game ${gameId} as ${name}` });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(10000, () => console.log("Server running on port 10000"));
