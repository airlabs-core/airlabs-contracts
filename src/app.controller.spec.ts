import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ethers } from 'ethers';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('root', () => {
    it('should return "Hello World!"', () => {
      expect(appController.getHello()).toBe('Hello World!');
    });
  });

  describe('custom quest requirement', () => {
    it('should be a custom quest', async () => {
      console.log('hello world');

      // contractAddress
      // functionName
      // functionArguments[]

      // const functionArgs: any[] = [1, 2];

      // function testF(arg1: any, arg2: any) {
      //   return [arg1, arg2];
      // }

      // testF(...functionArgs)

      const provider = new ethers.JsonRpcProvider('https://rpc.ankr.com/eth');
      // const provider = new ethers.EtherscanProvider();
      // await provider.getHistory('0x3e8c686f499c877d8f4afb1215b6f0935796b986');

      const tx = await provider.getTransaction(
        '0xb4f6311d59b2b9f77fb7ef13fcc77f7ab0896f99e0185f503c506b2e9dbdd7cb',
      );
      console.log('tx', tx);
    });
  });
});
