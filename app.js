// PlantDoctor App JS

const imageUpload = document.getElementById('imageUpload');
const cameraCapture = document.getElementById('cameraCapture');
const submitBtn = document.getElementById('submitBtn');
const preview = document.getElementById('preview');
const results = document.getElementById('results');
const plantName = document.getElementById('plantName');
const disease = document.getElementById('disease');
const suggestion = document.getElementById('suggestion');

let selectedFile = null;

function showPreview(file) {
  const reader = new FileReader();
  reader.onload = function (e) {
    preview.innerHTML = `<img src="${e.target.result}" alt="Preview" class="max-h-48 rounded-lg shadow-md" />`;
  };
  reader.readAsDataURL(file);
}

function handleFileInput(e) {
  const file = e.target.files[0];
  if (file) {
    selectedFile = file;
    showPreview(file);
    submitBtn.disabled = false;
    results.classList.add('hidden');
  }
}

imageUpload.addEventListener('change', handleFileInput);
cameraCapture.addEventListener('change', handleFileInput);

submitBtn.addEventListener('click', async () => {
  if (!selectedFile) return;
  submitBtn.disabled = true;
  submitBtn.textContent = 'Analyzing...';
  results.classList.add('hidden');

  const formData = new FormData();
  formData.append('image', selectedFile);

  try {
    const response = await fetch('/api/analyze', {
      method: 'POST',
      body: formData,
    });
    if (!response.ok) throw new Error('Failed to analyze image');
    const data = await response.json();
    plantName.textContent = `Plant: ${data.plant_name || 'Unknown'}`;
    disease.textContent = data.disease ? `Disease: ${data.disease}` : 'No disease detected';
    suggestion.textContent = data.suggestion || '';
    results.classList.remove('hidden');
  } catch (err) {
    plantName.textContent = '';
    disease.textContent = 'Error analyzing image.';
    suggestion.textContent = '';
    results.classList.remove('hidden');
  } finally {
    submitBtn.disabled = false;
    submitBtn.textContent = 'Submit';
  }
});