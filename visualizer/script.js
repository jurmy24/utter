let jsonData;
let currentChapterIndex = 0;
let currentBlockIndex = 0;

// Fetch the JSON data
fetch("story.json")
  .then((response) => response.json())
  .then((data) => {
    jsonData = data;
    document.getElementById("title").innerText = jsonData.title;
    displayBlock(); // Display the first block
  })
  .catch((error) => console.error("Error loading JSON:", error));

// Function to display the current block
function displayBlock() {
  const chapter = jsonData.chapters[currentChapterIndex];
  const block = chapter.blocks[currentBlockIndex];
  const contentElement = document.getElementById("content");
  contentElement.innerHTML = ""; // Clear previous content

  if (block.block_type === "story") {
    block.lines.forEach((line) => {
      const lineElement = document.createElement("p");
      lineElement.innerText = `${line.character}: ${line.text}`;
      contentElement.appendChild(lineElement);
    });
  } else if (block.block_type === "exercise") {
    block.exercise_options.forEach((exercise) => {
      const queryElement = document.createElement("p");
      queryElement.innerText = exercise.query || "";
      contentElement.appendChild(queryElement);

      if (exercise.answer_options) {
        const optionsElement = document.createElement("ul");
        exercise.answer_options.forEach((option) => {
          const optionItem = document.createElement("li");
          optionItem.innerText = option;
          optionsElement.appendChild(optionItem);
        });
        contentElement.appendChild(optionsElement);
      }
    });
  }

  // Update button states
  document.getElementById("prevBtn").disabled =
    currentChapterIndex === 0 && currentBlockIndex === 0;
  document.getElementById("nextBtn").disabled =
    currentChapterIndex === jsonData.chapters.length - 1 &&
    currentBlockIndex === chapter.blocks.length - 1;
}

// Function to navigate to the previous block
function prevBlock() {
  if (currentBlockIndex > 0) {
    currentBlockIndex--;
  } else if (currentChapterIndex > 0) {
    currentChapterIndex--;
    currentBlockIndex =
      jsonData.chapters[currentChapterIndex].blocks.length - 1;
  }
  displayBlock();
}

// Function to navigate to the next block
function nextBlock() {
  const chapter = jsonData.chapters[currentChapterIndex];
  if (currentBlockIndex < chapter.blocks.length - 1) {
    currentBlockIndex++;
  } else if (currentChapterIndex < jsonData.chapters.length - 1) {
    currentChapterIndex++;
    currentBlockIndex = 0;
  }
  displayBlock();
}
