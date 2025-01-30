# Client-side Operations

This stand-alone directory provides the following functionality for clients:
-   **Homomorphic Key Generation**
-   **Encoding and Encrypting Input Images**
-   **Decrypting Classification Results**


# Quickstart
1. Install Python librarys from requirements.txt
```bash
cd client-side-REDSEC
python3.9 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
2. Choose and mnist image from mnist sample and encode by running the following, where x is the number in your chosen sample.
```bash
python jpg_to_csv.py --image x.jpg
```
3. Generate the keys and encrypt the image using
```bash
sbatch encrypt.sh
```
4. Hope TFHE libraries play nice. Otherwise build from [tfhe](https://github.com/tfhe/tfhe).
5. Send eval key and ciphertext to server using
```bash
scp image.ctxt fsgf66@ncc1.clients.dur.ac.uk:/home2/fsgf66/project/REDsec/client
scp eval.key fsgf66@ncc1.clients.dur.ac.uk:/home2/fsgf66/project/REDsec/client
```
5. Wait for inference
7. Get the encrypted classsification result from the server.
```bash
scp fsgf66@ncc1.clients.dur.ac.uk:/home2/fsgf66/project/REDsec/client/network_output.ctxt .
```
8. Decrypt the classification using
```bash
sbatch decrypt.sh
```

## Key Generation

This functionality generates the secret key used for encryption and decryption 
as well as the evaluation key which will be outsourced to the cloud for 
encrypted inference. The evaluation key is primarily used for bootstrapping and 
keyswitching and is unable to perform decryption (ensuring the privacy of the 
encrypted input data).

* `make keygen` will generate the HE keypair for CPU-based inference with TFHE.
* `make redcufhe-keygen` will generate the HE keypair for GPU-based inference
  with REDcuFHE.

**Note:** A local GPU on the client is not necessary to generate keys with REDcuFHE.


## Encoding and Encrypting Images

REDsec expects images to be expressed in CSV format, where the first entry is 
an optional classification label to check for correctness, and is otherwise
ignored. Each subsequent entry is an integer representing the pixel value in a
specific color channel. For black and white images such as those employed by
MNIST, a pixel has a single number associated with it (from 0 to 255)
corresponding to the single color channel. For CIFAR-10 and ImageNet, a pixel is
three contiguous numbers (e.g. 7,129,5) that represent the red, green, and blue
channels respectively. 

1. Specify the format of the images (e.g. `export format=MNIST`)
2. Specify the filename of the image (e.g. `export image_path=mnist_test.csv`)
3. Run `make encrypt-image` to encrypt with TFHE and `make
   redcufhe-encrypt-image` to encrypt with REDcuFHE. 

## Decrypting Classification Results

After the cloud has computed the encrypted inference procedure, it will return
encrypted raw classification scores for each class (`network_output.ctxt`). The client decrypts the
result and outputs the class corresponding to the maximum score as the
classification result.

1. Specify the dataset (e.g. `export format=MNIST`)
2. Run `make decrypt-image` to decrypt `network_output.ctxt` and print the final
   classification result. 
