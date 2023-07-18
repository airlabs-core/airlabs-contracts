import { Injectable } from '@nestjs/common';
import { CreateErc20Dto } from './dto/create-erc20.dto';
import { UpdateErc20Dto } from './dto/update-erc20.dto';

@Injectable()
export class Erc20Service {
  create(createErc20Dto: CreateErc20Dto) {
    return 'This action adds a new erc20';
  }

  findAll() {
    return `This action returns all erc20`;
  }

  findOne(id: number) {
    return `This action returns a #${id} erc20`;
  }

  update(id: number, updateErc20Dto: UpdateErc20Dto) {
    return `This action updates a #${id} erc20`;
  }

  remove(id: number) {
    return `This action removes a #${id} erc20`;
  }
}
