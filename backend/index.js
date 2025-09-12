const tasks = require("./routes/tasks");
const connection = require("./db");
const stressCpu = require("./stress");
const cors = require("cors");
const express = require("express");
const app = express();
const { logger } = require("./utils/logger");

// connection();

// const fs = require('fs');
// const logStream = fs.createWriteStream('./tlogs/app.log', { flags: 'a' });

// console.log = (...args) => {
//   const now = new Date();
//   logStream.write(`${[now.toISOString()]}: ` + args.join(' ') + '\n');
// };


app.use(express.json());
app.use(cors());

app.get('/ok', (req, res) => {
    res.status(200).send('ok')
  })

app.use("/api/tasks", tasks);

app.get("/stress", (req, res) => {
    res.status(200).send('Stress Completed! counted: ' + stressCpu(5000000));
  })

app.get('/videoplayer', (req, res) => {
    const fs = require('fs');
    const range = req.headers.range
    const videoPath = './video.mp4';
    const videoSize = fs.statSync(videoPath).size
    const chunkSize = 1 * 1e6;
    const start = Number(range.replace(/\D/g, ""))
    const end = Math.min(start + chunkSize, videoSize - 1)
    const contentLength = end - start + 1;
    const headers = {
        "Content-Range": `bytes ${start}-${end}/${videoSize}`,
        "Accept-Ranges": "bytes",
        "Content-Length": contentLength,
        "Content-Type": "video/mp4"
    }
    res.writeHead(206, headers)
    const stream = fs.createReadStream(videoPath, {
        start,
        end
    })
    stream.pipe(res)
})

// app.get('/live', (req, res) => {
//     const { spawn } = require('child_process');
//     res.writeHead(200, {
//         'Content-Type': 'multipart/x-mixed-replace; boundary=ffserver'
//     });

//     const ffmpeg = spawn('ffmpeg', [
//         '-f', 'v4l2',              // Format for webcam
//         '-i', '/dev/video0',       // Input device (change for Windows/Mac)
//         '-f', 'mjpeg',             // Output format
//         '-q:v', '5',               // Quality
//         '-r', '25',                // FPS
//         '-'
//     ]);

//     ffmpeg.stdout.pipe(res);

//     ffmpeg.stderr.on('data', (data) => {
//         console.error('FFmpeg stderr:', data.toString());
//     });

//     req.on('close', () => {
//         ffmpeg.kill('SIGINT');
//     });
// });

const port = process.env.PORT || 8881;
app.listen(port, () => logger.info(`Listening on port ${port}...`));
